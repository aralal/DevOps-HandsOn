#Use the official Nginx image
FROM nginx:alpine

#Copy the static website files into the Nginx HTML directory
COPY ./static-site /user/share/nginx/html

#Expose port 80 for the web browser
EXPOSE 80

#Start Nginx
CMD ["nginx", "-g", "daemon off;"]

