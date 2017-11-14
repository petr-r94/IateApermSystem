#script
drawfunc = function(FUN,fname, width, height) {
  x = seq(from = -pi, to = pi, length.out = 50)
  y=FUN(x)
  png(fname, width, height)
  plot(x,y, type="l", lwd="3",col="green")
  grid(col=1)
  dev.off()
}

# drawfunc(function(x)1/x*sin(5*x),"1.png",640,480)