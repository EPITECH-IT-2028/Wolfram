NAME = wolfram

all: $(NAME) clean

$(NAME): 
	stack build
	cp `stack path --local-install-root`/bin/$(NAME)-exe $(NAME)

clean:
	find . -name "*~" -delete
	rm -f *.gcno
	rm -f *.gcda

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
