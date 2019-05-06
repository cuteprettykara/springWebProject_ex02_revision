package org.zerock.domain;

import java.util.Date;
import lombok.Data;

@Data
public class ReplyVO {
	private Long rno;
	private Long bno;
	private String replytext;
	private String replyer;
	private Date regdate;
	private Date updatedate;
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		ReplyVO other = (ReplyVO) obj;
		if (bno == null) {
			if (other.bno != null)
				return false;
		} else if (!bno.equals(other.bno))
			return false;
		if (replyer == null) {
			if (other.replyer != null)
				return false;
		} else if (!replyer.equals(other.replyer))
			return false;
		if (replytext == null) {
			if (other.replytext != null)
				return false;
		} else if (!replytext.equals(other.replytext))
			return false;
		if (rno == null) {
			if (other.rno != null)
				return false;
		} else if (!rno.equals(other.rno))
			return false;
		return true;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((bno == null) ? 0 : bno.hashCode());
		result = prime * result + ((replyer == null) ? 0 : replyer.hashCode());
		result = prime * result + ((replytext == null) ? 0 : replytext.hashCode());
		result = prime * result + ((rno == null) ? 0 : rno.hashCode());
		return result;
	}
	
	
}
