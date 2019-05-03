package org.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
	private int page;
	private int perPageNum;
	
	private String searchType;
	private String keyword;
	
	public Criteria(int page, int perPageNum) {
		this.page = page;
		this.perPageNum = perPageNum;
	}
	
	public Criteria() {
		this(1, 10);
	}
	
	// method for MyBatis SQL Mapper
	public int getRowFrom() {
		return (this.page - 1) * this.perPageNum;
	}
	
	// method for MyBatis SQL Mapper
	public int getRowTo() {
		return this.page * this.perPageNum;
	}
	
	public String[] getSearchTypeArr() {
		return searchType == null ? new String[] {} : searchType.split("");
	}
	
	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("page", this.page)
				.queryParam("perPageNum", this.perPageNum)
				.queryParam("searchType", this.searchType)
				.queryParam("keyword", this.keyword);
		
		return builder.toUriString();
	}
}
