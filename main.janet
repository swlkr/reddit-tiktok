(import sqlheavy/sqlheavy :prefix "")
(import osprey :prefix "")
(import tw :prefix "")
(import json)
(import ./import :as reddit)


(defmacro bundle [& sources]
  (let [folder "public"
        contents @""]

    (each f (os/dir folder)
      (when (string/has-prefix? "bundle." f)
        (os/rm (string folder "/" f))))

    (each src sources
      (as-> (string folder src) ?
            (slurp ?)
            (string "\n" ?)
            (buffer/push-string contents ?)))

    (let [checksum (string/format "%x" (hash (string contents)))
          src (string "/bundle." checksum ".js")
          filename (string folder src)]

      (spit filename contents)

      src)))


# (def -database-)
(db/connect "reddit-tiktok.sqlite3")

# (db/query "drop table if exists items")

(db/query `
create table if not exists items (
  id integer primary key,
  title text,
  url text,
  author text,
  author_url text,
  posted_at integer,
  created_at integer not null default(strftime('%s', 'now')))`)


# (def -models-)
(defmodel Item)


(defn load-items [src]
  (reddit/download src)

  (def- posts
    (as-> (string src ".json") ?
          (slurp ?)
          (json/decode ? true true)
          (filter |(false? (get $ :over_18)) ?)
          (filter |(= "link" (get $ :post_hint)) ?)))

  (each post posts
    (:insert Item {:author (post :author)
                   :author_url (post :author_url)
                   :url (post :url)
                   :title (post :title)
                   :posted_at (post :created_utc)})))

(when (empty? (:all Item))
  (each sub ["finance" "globalmacro"]
    (load-items sub)))


# middleware
(enable :logging)
(enable :static-files)


#(def -layout-)
(layout
  (doctype :html5)
  [:html {:class (tw "relative w-full h-full p-0 m-0")}
    [:head
     [:meta {:charset "utf-8"}]
     [:title "reddit-tiktok"]
     [:link {:rel "stylesheet" :href tw/href}]
     [:script {:src (bundle "/all.js") :defer ""}]]
    [:body {:class (tw "relative w-full h-full p-0 m-0")}
     response]])


(defn section [item]
  [:section {:class (tw "flex flex-col justify-center items-center h-screen w-full snap-start px-4")}
    [:h1 {:class (tw "text-2xl dark:text-white")}
     [:a {:href (item :url)
          :class (tw "underline")}
      (string/replace-all "&amp;" "&" (item :title))]]
    [:h2 {:class (tw "text-lg self-start dark:text-white")}
     [:a {:href (item :author_url)
          :class (tw "underline")}
      (item :author)]]])


(GET "/"
  (let [items (db/query "select * from items order by random() limit 2")]
    [:main {:class (tw "overflow-y-scroll snap snap-y snap-mandatory max-h-full max-w-lg mx-auto dark:bg-gray-800")}
      (map section items)]))


(GET "/next"
  (use-layout false)
  (content-type "text/html")

  (let [item (first (db/query "select * from items order by random() limit 1"))]
    (html/encode
      (section item))))


# read tailwind.min.css and grab only styles in use
(tailwind-min-css "tailwind.min.css")


(defn main [&]
  (server 9001))
