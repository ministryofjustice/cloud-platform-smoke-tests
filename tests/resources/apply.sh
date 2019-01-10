for f in ../*.sh; do
  bash "$f" -H && echo "--------------"  || break
done
