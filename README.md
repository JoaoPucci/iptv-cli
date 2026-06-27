# iptv-cli

A small terminal launcher for [iptv-org](https://github.com/iptv-org/iptv) playlists.

Browse channels with an `fzf` drill-down (country / category / language → channel)
and play the selected stream in `mpv`. Playlists are fetched live from iptv-org, so
the channel list always stays current — nothing is stored locally.

> This is a **player**. It hosts no channels and ships no streams; it only points
> `mpv` at the public playlists published by the iptv-org project.

## Dependencies

`curl`, `fzf`, `mpv`, `jq` (declared in the `.deb`, so `apt` pulls them in for you).

## Install

```sh
make deb                       # builds dist/iptv-cli_<version>_all.deb
sudo apt install ./dist/iptv-cli_0.1.0_all.deb
```

Uninstall with `sudo apt remove iptv-cli`.

## Usage

```sh
iptv-cli                 # interactive: pick country/category/language -> channel
iptv-cli countries/jp    # jump straight to any iptv-org playlist path
iptv-cli news            # shortcut for categories/news
iptv-cli --help
iptv-cli --version
```

**Controls** — selector: type to fuzzy-filter, ↑/↓ move, Enter select, Esc cancel.
mpv: `space` pause · `f` fullscreen · `m` mute · `9`/`0` volume · `q` quit.

### Use a different player

```sh
IPTV_CLI_PLAYER=vlc iptv-cli
```

## Notes

- Many entries are geo-restricted or rot over time — a black screen usually means
  that stream is dead or blocked for your region; just pick another channel.
- The `iptv-org` website lists *every* known channel, but only channels with a
  working stream URL appear here (the playlists are the streamable subset).

## Hacking on it

The whole program is one Bash script: [`src/iptv-cli`](src/iptv-cli). Edit it, then
`make deb` to rebuild the package. Packaging metadata lives in [`packaging/`](packaging/),
and the version is the single line in [`VERSION`](VERSION).

## License

MIT — see [LICENSE](LICENSE).
