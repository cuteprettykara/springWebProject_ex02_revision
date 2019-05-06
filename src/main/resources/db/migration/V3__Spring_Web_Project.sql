create table tbl_reply ( 
	rno number(10, 0),
	bno number(10, 0) NOT NULL,
	replytext varchar2(1000) NOT NULL, 
	replyer varchar2(50) NOT NULL, 
	regDate date default sysdate,
	updateDate date default sysdate
);

create sequence seq_reply;

alter table tbl_reply add constraint pk_reply primary key (rno);

alter table tbl_reply add constraint fk_reply_board
foreign key (bno) references tbl_board(bno);

insert into tbl_reply (rno, bno, replytext, replyer)
values(seq_reply.nextval, 1, '댓글 테스트1', 'replyer1');