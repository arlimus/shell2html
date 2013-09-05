# shell2html

Easily capture what happens in your shell in html output.


## usage

```bash
(mymachine) > shell2html out.html
> echo "Hello World"
Hello World
> echo -e "This is built on \e[32;1mGreen\e[0m-IT"
This is built on Green-IT
> exit
```

You can view the output out.html in your browser:

![Output of simple shell2html example](https://raw.github.com/arlimus/shell2html/master/misc/out1.png)

Another example with more configuration:
```bash
(mymachine) > shell2html out.html --bg dark -p solarized
> echo -e "Solarized \e[31;1mwriting\e[0m"
Solarized writing
> exit
```

![Output of solarized shell2html example](https://raw.github.com/arlimus/shell2html/master/misc/out2.png)


## limitations

Loads: No shell scripting, some caveats with shell-internal functions, doesn't yet grab the correct history, no custom styling.