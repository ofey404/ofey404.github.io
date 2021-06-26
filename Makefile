lang-ref:
	./tools/lang-ref.py _posts/

serve: lang-ref
	bundle exec jekyll serve

new:
	./tools/new-post.sh _posts/
	./tools/lang-ref.py _posts/

.PHONY: lang-ref