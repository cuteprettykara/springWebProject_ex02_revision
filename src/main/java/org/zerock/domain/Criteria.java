package org.zerock.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
	private int page;
	private int perPageNum;
	
	public Criteria(int page, int perPageNum) {
		this.page = page;
		this.perPageNum = perPageNum;
	}
	
	public Criteria() {
		this(1, 10);
	}
	
	// method for MyBatis SQL Mapper
	public int getPageStart() {
		return (this.page - 1) * this.perPageNum;
	}
	
	// method for MyBatis SQL Mapper
	public int getPageEnd() {
		return this.page * this.perPageNum;
	}
}
