test1(){
  echo Hello
}
test2(){
  echo x:$x
}
# here when we run test2 it runs in subshell so when we provide x=100 it stores in local shell memory(temporary memory) so to store in process env
# use export x=100 then x value stores in process env
#any script can access x value
# when we access variable value in current shell then we can use x=100
test3(){
  echo "first argument:$1"
  echo "second argument:$2"
  echo "all arguments:$*"
  echo "no of arguments:$#"
}
test4(){
  y=200
  echo y:$y
}
test5(){
  echo z:$z
}