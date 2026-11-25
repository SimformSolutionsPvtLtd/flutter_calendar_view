# calendar_view: maintainer guide for coding agents

These instructions are for working **on** the package. Guidance for apps that **use** it ships in
`skills/` (see below).

## Keep these in sync with any change

When a public API, default or behavior changes, update in the same PR:

1. The dartdoc comments (`///`) of the changed API.
2. `README.md` and `doc/documentation.md`.
3. `CHANGELOG.md` (breaking changes are marked `[BREAKING]`).
4. The `example/` app.
5. **`skills/`**. Skills ship to users with the package, so a stale skill makes their coding
   agents write code that doesn't compile.

## Package skills (`skills/`)

The package publishes agent skills following
[Dart package skills](https://dart.dev/tools/pub/package-skills). Users install them with
`dart run skills@ get`.

| Skill                     | Task                                                              |
|---------------------------|-------------------------------------------------------------------|
| `calendar-view-events`    | Create, update, filter and recur events (`EventController`)       |
| `calendar-view-views`     | Add and control the calendar widgets (`references/` per view)     |
| `calendar-view-theming`   | Theme, headers and localization                                   |
| `calendar-view-migration` | Migrate from 2.0.0 to 3.x                                         |

Rules:

- One skill per user task, not per class. Add a skill only for a new task (for example a
  migration), otherwise extend the existing one.
- Directory name = frontmatter `name` = `calendar-view-<topic>`: lowercase letters, digits and
  single hyphens only. Don't use the package's underscore (`calendar_view-…`): the Agent Skills
  spec forbids it in `name`, and `skills_lint` rejects it.
- The description says what the skill does and when to use it (max 1024 characters).
- Keep `SKILL.md` under 500 lines. Move long tables to `references/` and link them with a relative
  path from the skill root.
- Write rules an agent can follow and complete Dart examples that compile. State behavior verified
  in `lib/`, not what the docs claim.
- Don't hard-code a package version in examples or commands.
- `skills/` must not be excluded by `.gitignore` or a `.pubignore`.
- The skills describe the **latest** major version (3.x). Each `[BREAKING]` CHANGELOG
  entry gets a row in `calendar-view-migration` and updates every other skill that shows the
  old API, in the same PR.
- Every skill starts with a workflow that inspects the project first, then gives rules, then
  complete examples. Examples that are fragments say what their placeholders stand for.

### Validate

Install [`skills_lint`](https://pub.dev/packages/skills_lint) globally and run it from the
repository root:

```bash
dart pub global activate skills_lint
dart pub global run skills_lint --ignore-config -d skills --check-relative-paths --check-relative-paths-within-skill=true --published-skill-name --published-skill-name-pubspec_path=pubspec.yaml --pub-archive-includes-skill --check-trailing-whitespace --disallowed-field
```

To test an install, create a throwaway Flutter app, add `calendar_view` with a `path:`
dependency, run `dart run skills@ get --all --agent claude` and check `.claude/skills/`. Only
**direct** dependencies are scanned. Paste the skill's Dart examples into that app and run
`flutter analyze`.

## Verifying changes

- Run `flutter analyze` and `flutter test`.
- Run the `example/` app for UI changes.

## Pull requests

Follow `.github/pull_request_template.md`: a Conventional Commit title (`feat:`, `fix:`,
`docs:`; add `!` for breaking changes) and migration instructions for breaking changes.
