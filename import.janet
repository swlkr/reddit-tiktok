(import json)
(import http)


(defn post [source p]
  (merge p {:author_url (string "https://old.reddit.com/u/" (get p :author))}))


(defn download [category]
  (as-> (string "https://old.reddit.com/r/" category ".json") _
        (http/get _)
        (get _ :body)
        (json/decode _ true true)
        (get-in _ [:data :children])
        (map |($ :data) _)
        (filter |(not (empty? ($ :url))) _)
        (map |(post category $) _)
        (spit (string category ".json") (json/encode _))))
