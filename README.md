## Mass-Vision
A Ruby on Rails photo archive for lazy data lovers

#### Introduction
This application, currenly called *Mass-Vision* (until I think of something more clever), was built to support large batch image uploads, and to scrape as much meaning as possible from photographic metadata and location data, where it exists.

It relies on MongoDB for the database backend, Apache Tika for metadata scraping, RIIIF for an IIIF-compatible image service, and Delayed Job for asynchronous upload processing.

This project is very much incomplete, though cloning the master branch at any time (and installing all software prerequisites) should get you a working application.
