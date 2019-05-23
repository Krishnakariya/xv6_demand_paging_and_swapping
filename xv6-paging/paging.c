#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
#include "paging.h"
#include "fs.h"

static int count=0;
/* Allocate eight consecutive disk blocks.
 * Save the content of the physical page in the pte
 * to the disk blocks and save the block-id into the
 * pte.
 */
void
swap_page_from_pte(pte_t *pte)
{
	//cprintf("in: swap_page_from_pte\n");
	//cprintf("bp before\n");
	uint block_page = balloc_page(ROOTDEV);
	//cprintf("bp after\n");
	char * pte_page = (char * ) ((*pte) & 0xfffff000);
	//cprintf("wptd before\n");
	write_page_to_disk(ROOTDEV, P2V(pte_page), block_page);
	//cprintf("wptf after\n");
	block_page = block_page << 12;
	*pte = (*pte & 0x00000fff) | block_page | PTE_SW;	//maybe up or down thiws line
	*pte = (*pte) & (~PTE_P);
	//cprintf("PTE in swap_page_from_pte: %x",(*pte));

	//cprintf("brfore kree\n");
	kfree(P2V(pte_page));
	//cprintf("after kfree\n");
	switchuvm(myproc());
//	cprintf("out: swap_page_from_pte\n");
}

/* Select a victim and swap the contents to the disk.
 */
int
swap_page(pde_t *pgdir)
{
//	cprintf("in: swap_page\n");
	//1	iterate over all user pages and find a page whose access bit is not set.
	//2 if no such page is found then reset the access bit of any 1 user page.
	//3 repeat 1
	pte_t * victim;
	while ((victim = select_a_victim(pgdir))==0)
	{
		//cprintf("while of swap_page\n");
		clearaccessbit(pgdir);
	}
	//cprintf("swapping");
	swap_page_from_pte(victim);

	//panic("swap_page is not implemented");
	return 1;
}

/* Map a physical page to the virtual address addr.
 * If the page table entry points to a swapped block
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address(pde_t *pgdir, uint addr)
{
	//cprintf("in: map_address\n");
	char * kpage;
	//count+=1;
	while ((kpage = kalloc()) == 0)
	{
		//cprintf("while of map_address\n");
		swap_page(pgdir); // what to do of return value, always return 1?
		continue;
		//cprintf("%d\n",count );
		//panic("out of physical pages");
	}
	memset((void *)kpage, 0, PGSIZE);
	//mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
	//allocuserpage(pgdir, (void*)addr, 4096, V2P(kpage), PTE_P | PTE_W | PTE_U ); // what flags to put?
	

	//error prone:
	uint phy_addr = (uint) V2P(kpage);
	pte_t * pte = uva2pte_1(pgdir,addr);
	*pte =  phy_addr | ((*pte)&0x00000fff) | PTE_P | PTE_W | PTE_U;
	*pte = *pte & (~PTE_SW);
	//cprintf("pte in map_address: %x\n",(uint)(*pte));

	switchuvm(myproc());
	//panic("map_address is not implemented");
	//cprintf("out: map_address\n");
}

/* page fault handler */
void
handle_pgfault()
{
	
	count+=1;
	
	unsigned addr;
	struct proc *curproc = myproc();

	asm volatile ("movl %%cr2, %0 \n\t" : "=r" (addr));
	addr &= ~0xfff;
	
	//cprintf("%d\n", addr);

	if (addr>KERNBASE)
	{
	//	cprintf("Kernel page fault");
		
	}
	


	pde_t * cpgdir = curproc->pgdir;
	pte_t * pte = uva2pte(cpgdir, addr);
	
	//cprintf("pte in handle_pgfault: %x\n",(uint)(*pte));

	if ((*pte & PTE_P) == PTE_P)
	{	
		cprintf("kya karein?");
	}	
	else if ((*pte & PTE_SW) == PTE_SW)
	{
		get_page_from_disk(cpgdir,addr);
		
	}else{
		map_address(cpgdir , addr);	
	}
	
}

void get_page_from_disk(pde_t* pgdir, uint addr)
{
	//cprintf("in: get_page_from_disk\n");
	int bno = getswappedblk(pgdir, addr);
	char * kpage;
	while ((kpage = kalloc()) == 0)
	{
		swap_page(pgdir); // what to do of return value, always return 1?
		continue;
		//cprintf("%d\n",count );
		//panic("out of physical pages");
	}
	read_page_from_disk(ROOTDEV, (char*) (kpage), bno);
	
	

	//allocuserpage(pgdir, (void*)addr, 4096, V2P(kpage), PTE_P | PTE_W | PTE_U ); : protection fault dega!
	pte_t * pte = uva2pte(pgdir,addr);
	//cprintf("pte in get_page_from_disk1: %x\n",(uint)(*pte));
	uint phy_addr = (uint) V2P(kpage);
	
	*pte =  phy_addr | ((*pte)&0x00000fff) | PTE_P;
	*pte = *pte & (~PTE_SW);
	
	//cprintf("pte in get_page_from_disk: %x\n",(uint)(*pte));

	bfree_page(ROOTDEV, bno);
	switchuvm(myproc());
}