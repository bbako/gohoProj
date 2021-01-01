package org.com.service;

import java.util.Date;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.com.vo.MemberVO;
import org.springframework.stereotype.Service;

@Service("memberService")
public class MemberServiceImpl implements MemberService {
	
	@Inject
	SqlSession sess;
	
	String namespace = "memberMapper";

	@Override
	public void keepLogin(String userId, String id, Date sessionLimit) {
	}

	@Override
	public MemberVO login(MemberVO vo) {
		return sess.selectOne(namespace+".login", vo);
	}

	@Override
	public MemberVO checkSessionKey(String value) {
		return null;
	}

	@Override
	public void register(MemberVO vo) {
		sess.insert(namespace+".regist", vo);
	}
}
