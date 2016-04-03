## Mass-Vision
A Ruby on Rails photo archive for lazy data lovers

#### Introduction
This application, currenly called *Mass-Vision* (until I think of something more clever), was built to support large batch image uploads, and to scrape as much meaning as possible from photographic metadata and location data, where it exists.

It relies on MongoDB for the database backend, Apache Tika for metadata scraping, RIIIF for an IIIF-compatible image service, and Delayed Job for asynchronous upload processing.

This project is very much incomplete, though cloning the master branch at any time (and installing all software prerequisites) should get you a working application.

#### Installation

I'm running this application on OS X 10.11, though it should be easy to deploy on Linux as well.


To install MongoDB on OS X:

```
brew update
brew install mongodb
```
Install Apache Tika, for metadata extraction:

```
brew install tika
```

Install ImageMagick, a dependency for [RIIIF](https://github.com/curationexperts/riiif):

```
brew install imagemagick --with-ghostscript --with-tiff --with-jp2
```
Finally, clone the repo:

```
cd ~
git clone https://github.com/sgbalogh/mass-vision.git

```

From there, you can run the database migrations (`rake db:migrate`), and try booting up the application (`rails s -b 0.0.0.0`). To start a Delayed Job worker, run the rake task `rake jobs:work`, and hit Ctrl-C when you are ready to stop the worker.
