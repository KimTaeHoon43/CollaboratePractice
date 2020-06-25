package coma.spring.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/msg/")
public class MsgController {
	@Autowired
	private HttpSession session;

	@RequestMapping("msg")
	public String toMsg() {
		System.out.println("쪽지보내기");
		return "/";
	}
	
}
