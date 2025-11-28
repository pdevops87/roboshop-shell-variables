for i in 10 20 30; do
  echo "iterate numbers: $i"
done

read -p "Enter x value:" x
while [ $x -gt 0 ]; do
    echo $x
    x=$((x-2))
done