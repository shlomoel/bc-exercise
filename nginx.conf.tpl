http {
    upstream backend {
        %{ for i in range(1, number_of_containers + 1) ~}
        server web${i}:80;
        %{ endfor ~}
        }
    server {
        listen 80;

        location / {
            proxy_pass http://backend;
        }

        location /health {
            return 200 'load balancer healthy';
        }
    }
}

events {}