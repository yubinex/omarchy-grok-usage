# Omarchy Grok Usage

Adds a **Grok** tab to Omarchy's built-in Agents panel without adding another
bar icon or replacing the Claude and Codex UI.

The tab shows your SuperGrok tier, the live weekly subscription limit and
reset time, how much of that limit each product used (Grok Build, Grok Chat on
web and apps, and any others xAI reports), on-demand spend and prepaid credits
when your account has them.

## Installation

Sign in to Grok Build first:

```bash
grok login
```

Then add and enable the plugin:

```bash
omarchy plugin add https://github.com/yubinex/omarchy-grok-usage.git --enable
```

The Grok tab appears in the existing **Agents** panel as soon as the first
collection finishes. The service refreshes every five minutes; restart the
shell to force an immediate reload:

```bash
omarchy restart shell
```

## Data sources and boundaries

| Data | Source | Scope |
| --- | --- | --- |
| Subscription tier, weekly limit, and reset | Grok Build's authenticated billing endpoint | Account-wide shared subscription pool, including web and app use. |
| Per-product usage (Grok Build, Grok Chat, ...) | Same billing endpoint | Each product's share of the weekly pool, as whole percentages. |
| On-demand spend and prepaid credits | Same billing endpoint | Shown only when the account has an on-demand cap or a prepaid balance. |

Token charts are intentionally omitted. Local session records cannot be counted
reliably and do not cover web or app use, so the billing limits are the only
usage figure shown.

The collector uses the existing Grok login at `~/.grok/auth.json`. Credentials
are never written to Omarchy's usage record, printed, or sent anywhere except
Grok's HTTPS CLI-proxy endpoint. The record is written as
`~/.local/state/omarchy/agents/usage/grok.json` with mode `0600`.

## Troubleshooting

Run the collector directly to see its current result:

```bash
/usr/bin/python3 ~/.config/omarchy/plugins/yubinex.grok-usage/bin/grok-usage --write
```

If the record says that authentication is unavailable, restore the CLI session:

```bash
grok login
```

To remove the plugin:

```bash
omarchy plugin remove yubinex.grok-usage --yes
rm -f ~/.local/state/omarchy/agents/usage/grok.json
```

## License

[MIT](LICENSE)
