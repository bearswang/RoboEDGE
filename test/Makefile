all:build

run-collect:
	python3 SockCollector.py $(alg)

run-feeder:
	./wifi-search.sh &
	python3 $(alg).py