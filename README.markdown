Link-O-Rama
===========
This is a pet project based on a happy idea we had while we were having lunch. Why don't make a competition out of it? Why not go full-stack and learn some new tricks?

The Idea
--------
The basic idea is to generate an app that stores links and offers basic search over them. Consisting on the following parts:

  - A bookmarklet, so you can easily add new urls
  - A backend that receives the urls and manages the indexation and information retrieval
  - A search engine, so you are able to search inside those urls
  - A javascript frontend of only one HTML page

My implementation will be a mechanical-turk google. Free access for everyone and free insertion.


My chosen stack
---------------
Ruby, javascript, backbone.js, jquery, goliath, redis, mongodb


Description
-----------
Bookmarklet

Backend
  Server
  Dispatcher
    Worker

Frontend
