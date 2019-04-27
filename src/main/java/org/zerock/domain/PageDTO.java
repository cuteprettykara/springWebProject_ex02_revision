package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	private int totalCount;

	private int startPage;
	private int endPage;
	
	private boolean prev;
	private boolean next = true;
	
	private int displayPageNum = 10;
	
	private Criteria cri;

	public PageDTO(Criteria cri, int totalCount) {
		this.totalCount = totalCount;
		this.cri = cri;
		
		this.endPage = (int) Math.ceil(cri.getPage() / (double)displayPageNum) * displayPageNum;
		
		this.startPage = endPage - displayPageNum + 1;
		
		int realEndPage = (int) Math.ceil(totalCount / (double)cri.getPerPageNum());
		
		if (realEndPage < endPage) {
			this.endPage = realEndPage;
			this.next = false;
		}
		
		this.prev = this.startPage == 1 ? false : true;
	}
	
	
}
