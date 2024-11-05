package auth;


import User;

public interface user_d {

	boolean addUser(User user);
	boolean isValidUser(String username, String password);
}