### Introduction

This is a simple application for fruit

### Get started
To run it:

```sh
$ git clone git@github.com:abruzzi/fruit.git
$ cd fruit
$ bundle install
$ rackup
```

touch a new file named `data` with content like:

```json
{
    "message": "五仁滚出月饼界"
}
```

and then use the `curl` to send:

```sh
$ curl -X POST -H "Content-Type: application/json" -d@data http://localhost:9292/
```

and you should see the message itself echo in console.

#### Develop

So if you want to do some development on this, here are something you should know:

1.  `guard` to start the guard server
2.  `livereload` to live reload, you need a [browser plugin](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei) here
3.  use `sass` and `haml` for style and HTML corespondingly

Have fun!
