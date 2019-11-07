## Intro

Progress bar is a small module written in [vlang](https://github.com/vlang/v) to create progress bar on cli. It's a port of [doches/progressbar](https://github.com/doches/progressbar). It aims to provide complete functionality of the original project.

Currently only progress bar has been implemented and nothing is being exported.

![](screenshots/screenshot.png)

## Usage
`demo.v` gives an overview of how to use this module.
Example:
```
import progressbar

fn main() {
  p := progressbar.Progressbar{}
  steps := 50
  p.new('Label', steps)
  for i := 0; i < steps; i++ {
      // logic...
        p.increment()
  }
}
//when you are done call finsih()
p.finish()
```
You can pass in your own style using `new_with_format(label string, max int, format []byte]` instead of `new()`:
```
p.new_with_format('Your Label', num_steps, [`O`,`.`,`O`]
```
Output:
```
Your Label O...................O ETA0h0m0s
```

## Building

First clone the repo

```
https://github.com/Waqar144/progressbar.git
```

Then

```
cd progressbar
v build progressbar.v
```
Or if you want to build it as a module
```
v build module ~/path/to/dir/progressbar
```
### Running the demo
```
cp progressbar/demo.v ./
v run demo.v
```

## Contributing
Feel free to clone and contribute. All contributions are welcome.
It won't build on windows, but it's easily portable to windows. If you are using windows you can help porting this to windows.

## License
MIT
