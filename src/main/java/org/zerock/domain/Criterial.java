package org.zerock.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criterial {

	private int pageNum; //페이지 번호 
	private int amount;	//화면당 레코드 개수
	
	private String type; //제목 내용 저자
	private String keyword;	//검색어
	
	public Criterial() {
		this(1, 10);
	}
	
	public Criterial(int pageNum, int amount) {
		this.amount = amount;
		this.pageNum = pageNum;
	}
	
	//type 검색 조건을 분리! TCW -> T | C | W 개별적으로 분리
	public String[] getTypeArr() {
		return type == null? new String[] {}: type.split("");
	}
	
	/*
	 * T : 제목
	 * C : 내용
	 * W : 저자
	 * 
	 * TDW(제,내,저), TW(제, 저)
	 * type >> TCW -> T|C|W - > 하나 문자열을 개별 문자열로 분리 
	 */
}
