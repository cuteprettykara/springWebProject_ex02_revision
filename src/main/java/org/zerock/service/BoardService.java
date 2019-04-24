package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardVO;

public interface BoardService {
	
	public BoardVO get(Long bno);

	public List<BoardVO> getList();

	public void register(BoardVO board);
	
	public boolean modify(BoardVO board);
	
	public boolean remove(Long bno);
}
