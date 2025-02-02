import requests
import multiprocessing
import time
from concurrent.futures import ThreadPoolExecutor

def send_request(url):
    headers = {'accept': 'application/json'}
    while True:
        try:
            print(f"Sending request to {url}")
            requests.get(url, headers=headers, timeout=1)
        except:
            continue

def check_health():
    urls = [
        'http://localhost:8000/health',
        'http://localhost:8000/metrics-json',
        'http://localhost:8000/collect'
    ] * 2  # Multiply URLs to create more endpoints to hit

    # Create more processes
    process_count = multiprocessing.cpu_count() * 2
    processes = []
    
    for _ in range(process_count):
        for url in urls:
            p = multiprocessing.Process(target=send_request, args=(url,))
            p.start()
            processes.append(p)

    for p in processes:
        p.join()

if __name__ == "__main__":
    check_health()
