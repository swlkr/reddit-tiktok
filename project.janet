(declare-project
  :name "reddit-tiktok"
  :description "What would happen if reddit looked like tiktok"
  :dependencies ["https://github.com/swlkr/osprey"
                 "https://github.com/swlkr/tw"
                 "https://github.com/swlkr/sqlheavy"
                 "https://github.com/janet-lang/json"
                 "https://github.com/joy-framework/http"]
  :author "Sean Walker"
  :license "MIT"
  :url ""
  :repo "")

(phony "server" []
  (os/shell `find . -type f \( -name "*.janet" -o -name "*.sql" -o -name "all.js" \) | entr -r -z -c janet main.janet`))

(phony "repl" []
  (os/shell `janet -e "(import spork/netrepl) (netrepl/server)"`))
