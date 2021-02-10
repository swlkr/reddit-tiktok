# reddit-tiktok

_This is an example app showing one way to get sqlite, tailwind, vanilla js and osprey working together._

## Getting started

Clone this repo:

```sh
git clone https://github.com/swlkr/reddit-tiktok.git \
cd reddit-tiktok
```

Install the deps

```sh
jpm deps
```

Start the server

```sh
janet main.janet
```

This will do a few things on startup for the first time:

1. Download two json files from reddit
2. Create a sqlite database and a table in that sqlite database
3. Insert rows for every json entry from reddit's /r/finance and /r/globalmacro subs
4. Create a "model" with `pragma table_info`
5. Cache bust the `all.js` file by creating a `bundle.<hex value>.js` file
6. Read the very large ~5MB `tailwind.min.css` file and pick out just the classes it needs with `tw` and create a `tw.<hex value>.css` file
5. Start the http server

## The stack

- [osprey](https://github.com/swlkr/osprey)
- [tw](https://github.com/swlkr/tw)
- [sqlheavy](https://github.com/swlkr/sqlheavy)
- vanilla js

All logic exists in two files:

- main.janet (the main logic file where http requests are handled)
- import.janet (where reddit's json is downloaded)

## main

`main.janet` has quite a few things going on, the ui bits are at the bottom:

- `layout`
- `section`
- `GET "/"`
- `GET "/next"`

Check it out and happy hacking!
