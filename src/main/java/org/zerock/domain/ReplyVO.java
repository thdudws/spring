package org.zerock.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/*CREATE table tbl_reply (
	    rno number(10,0),
	    bno number(10, 0) not null,
	    reply VARCHAR2(1000) not null,
	    replyer VARCHAR2(50) not null,
	    replyDate date DEFAULT sysdate,
	    updateDate date DEFAULT sysdate
	);*/

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReplyVO {

	private Long rno;
	private Long bno;
	
	private String reply;
	private String replyer;
	
	private Date replyDate;
	private Date updateDate;
	
}
