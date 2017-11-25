# bitclock
a digital clock for your terminal that automatically resizes itself, with customizable colors!

## usage
```
$ gem install bitclock
```

## command-line execution
```
$ bitclock
                                                                           

        ▮▮  ▮▮▮▮▮▮▮▮▮▮      ▮▮▮▮▮▮▮▮▮▮  ▮▮▮▮▮▮▮▮▮▮      ▮▮▮▮▮▮▮▮▮▮  ▮▮▮▮▮▮▮▮▮▮
        ▮▮          ▮▮  ▮▮          ▮▮  ▮▮      ▮▮  ▮▮          ▮▮          ▮▮
        ▮▮          ▮▮      ▮▮▮▮▮▮▮▮▮▮  ▮▮      ▮▮      ▮▮▮▮▮▮▮▮▮▮  ▮▮▮▮▮▮▮▮▮▮
        ▮▮          ▮▮  ▮▮  ▮▮          ▮▮      ▮▮  ▮▮          ▮▮          ▮▮
        ▮▮          ▮▮      ▮▮▮▮▮▮▮▮▮▮  ▮▮▮▮▮▮▮▮▮▮      ▮▮▮▮▮▮▮▮▮▮  ▮▮▮▮▮▮▮▮▮▮ 
                                                                             
```
you can optionally give ANSI color names as arguments
```
$ bitclock magenta
```
or specify different colors for hours, minutes and seconds:
```
$ bitclock red green blue
```
t's also possible to add time delta to shift time, just add a number (positive
or negative) to the arguments. it's counted in hours:
```
$ bitclock -2.5
```


## thanks
this gem uses *Rainbow*, to get a cheerful nerdy looks.

thanks for visiting this repo, it's my first gem and it's just a start!

