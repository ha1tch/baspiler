# baspiler

Baspiler is an informal way to describe game logic, influenced by classic BASIC flavors like QuickBasic, Atari Basic, and Sinclair Basic. It's not meant to be executable code—just a way to express how a game should work. It looks like a BASIC program, but it’s not something you’d actually run.

Instead, this description is used to generate real, working code in Python, Lua, or JavaScript. So far, it’s been successfully tested with Pygame, Love2D, and HTML5 Canvas. However, only trivial game tests have been produced so far, and it's still highly experimental. We don’t yet know if this technique will be useful for creating more complex, non-trivial games.

The core idea is that you don’t need to be an expert programmer to write BASIC. By using this simple format, non-programmers can design games that target multiple platforms, all from a single BASIC-like game logic description.


# usage:

Assuming you have an LLM like Llama 3.1 running locally, feed the prompt followed by the BASIC source code to it, and generate the Javascript output of the game.

Work is ongoing to automate the process as if you were using a real compiler.

![screenshot of the trivial inbadders game compiled to html5 canvas from BASIC source](inbadders.png "inbadders")
