import requests
import time
import argparse

def generate_http_traffic(urls, count, delay):
    for url in urls:
        for _ in range(count):
            try:
                response = requests.get(url)
                print(f"Sent request to {url}, Status Code: {response.status_code}")
            except requests.exceptions.RequestException as e:
                print(f"Request failed for {url}: {e}")
            time.sleep(delay)

def main():
    parser = argparse.ArgumentParser(description="Generate HTTP network traffic for testing.")
    parser.add_argument("-f", "--file", required=True, help="File containing list of target URLs (one per line)")
    parser.add_argument("-c", "--count", type=int, default=10, help="Number of requests to send per URL (default: 10)")
    parser.add_argument("-d", "--delay", type=float, default=1.0, help="Delay between requests in seconds (default: 1.0)")
    
    args = parser.parse_args()
    
    with open(args.file, "r") as file:
        urls = [line.strip() for line in file.readlines() if line.strip()]
    
    generate_http_traffic(urls, args.count, args.delay)
    
if __name__ == "__main__":
    main()
