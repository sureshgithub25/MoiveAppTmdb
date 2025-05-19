# Movie App

This app follows the MVVM pattern and uses SwiftUI for the user interface.

## Features Implemented

1. **Home Tab**

   * Fetches data from two APIs: *Now Playing* and *Trending* movies.
   * Supports pagination.
   * Data is saved in Core Data and fetched from Core Data in case of API failure.
   * A *Saved* button displays bookmarked movies.
   * Users can bookmark movies only on the Movie Detail page.

2. **Search Tab**

   * Allows searching for movies.

## Features Not Implemented (due to time constraints)

1. Data is not being fetched from Core Data in batches.
2. No error UI state is shown when data is unavailable.

---

**To run the app:**
Install and launch the app, which will load the Home page and fetch the data.
