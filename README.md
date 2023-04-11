# TheMovieDB App

## Overview

Demo iOS App built on swiftUI for consuming movies from the [TMDB api](https://developers.themoviedb.org/3/).

The app consists of a main view where it shows the most popular movies right know in a scrollable list, supports infinite scrolling, tapping on a movie shows a detail of the movie and the ability to add it to a watch list, which is persisted locally. Also supports remote search for looking up any movie.

The app was built on SwiftUI using async / await and Combine, using an MVVM architecture, URLSession for network requests, URLCache for image caching and unit testing with XCTest.

## Installation

For running the app you will need an `API token`, for this you will need an account in themoviedb, you can create one [here](https://developers.themoviedb.org/3/getting-started/introduction).

Once you have an account you can get the `API Read Access Token (v4 auth)` from your [account settings](https://www.themoviedb.org/settings/api). Note that this is different from the `API key`, `API token` was introduced in v3 of TMDB API, more info [here](https://developers.themoviedb.org/3/getting-started/authentication).

Once you get the token you will need to setup an `.xcconfig` file. This file is not committed to not expose sensitive data.

In the root folder you will find a `sample.xcconfig`, which shows a sample file of the config file.

Duplicate this file, and name it to something of your liking, for example: `env.xconfig` and paste your API token in the placeholder.

For selecting this new config go to the project settings, under info tab, on configurations section, select this new configuration set, in our example `env` for both debug and release.

## Architecture

This project uses an MVVM architecture, where the model is divided in layers: network and persistence, viewModels are the only ones who talk to this layers and views just consume data from the view models.

### Network

The network layer exposes the singleton `APIClient` for making requests to the api. It exposes different async functions for querying the data and returns plain models from the models folder, (such as Movies, Genres, etc).

The APIClient internally implements a custom `Endpoint` struct which serves as builder for URLRequests enabling to use chaning and provides a simple and clean api for creating requests which reduces the duplication of code.

The APIClient is injected a `NetworkClient` which takes the endpoint, builds the URLRequest from it, sends it to the network and returns a `Response` which wraps the result of the response, in case of success it may contain data and in case of error it will have the error variable populated.

The APIClient will get this `Response` and similar to `Endpoint` provides an api enabling to use different chain operators to decode the data with a JSONDecoder or throw an errors in case of and error or also different HTTP response codes.

`NetworkClient` is a protocol which has one function which is `sendRequest` receiving an `Endpoint` and returning a `Response`. This allows to abstract and encapsulate URLSession in the network layer, so different NetworkClient can be implemented without needing to re write the entire network layer, in this case it was implemented `URLSessionNetworkClient` using URLSession, but changing to other solution can be done without to much hassle. Also enables a spy networkClient to be injected to the `APIClient` for mocking up network requests and test the APIClient without actually reaching the network. Note that the implementation of `URLSessionNetworkClient` is really small and conveys well with the Single Responsibility principle making the network client being only responsable for making the request without doing the decoding or error handling.

### Image caching

The app heavily relies on images, so image caching gives a drastically better user experience. SwiftUI provides an AsyncImage view which loads up images but does not support image caching. A custom view, CacheAsyncImage, was implemented which displays images supporting caching.

CacheAsyncImage holds an `ImageLoader` StateObject which makes use of URLCache and URLSession for querying and caching images.

### Persistence

The watch list is persisted locally. Movies are serialized as json and persisted to a file. To avoid unnecessary read and writes to the file system the list is loaded in memory when the app is foregrounded and persists to file when the app goes to background.

MoviePersistence exposes two async functions for saving and getting the watch list from disk. Inside it has an instance of `WatchListDiskOperator`, which is the one who actually makes the calls to disk. This `WatchListDiskOperator` implements the `DiskOperator` protocol by only needing to provide a collection name and the type of model that will be saved which needs to be codable.

`DiskOperator` is a protocol which has already implemented functions for writing and reading to files
