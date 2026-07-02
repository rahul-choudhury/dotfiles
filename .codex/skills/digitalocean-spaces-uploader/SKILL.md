---
name: digitalocean-spaces-uploader
description: Upload local files to DigitalOcean Spaces for the Growth Panda account using the configured AWS CLI profile. Use when the user asks Codex to upload files to the growthpanda Space, put files in a Spaces folder/prefix, return a public DigitalOcean Spaces link, test Spaces uploads, list or delete uploaded Spaces objects, or automate the local spaces-upload workflow.
---

# DigitalOcean Spaces Uploader

## Defaults

Use these defaults unless the user says otherwise:

- Bucket: `growthpanda`
- Region: `blr1`
- Endpoint: `https://blr1.digitaloceanspaces.com`
- AWS profile: `do-spaces`
- Public URL base: `https://growthpanda.blr1.digitaloceanspaces.com`

Do not ask the user to paste a Spaces secret into chat. Assume the profile is already configured; if authentication fails, tell the user to run `aws configure --profile do-spaces`.

## Upload Workflow

Prefer the installed helper at `/Users/rahul/.local/bin/spaces-upload` when present. Otherwise run the bundled `scripts/spaces-upload` from this skill.

Require the user or task context to specify a destination folder/prefix. Use `/` only when the user explicitly wants the bucket root. Spaces folders are key prefixes, so missing folders do not need to be created first.

Run:

```bash
spaces-upload <local-file> <folder-or-prefix>
```

Examples:

```bash
spaces-upload ~/Downloads/video.mp4 fft
spaces-upload ~/Downloads/image.jpeg client-assets/images
spaces-upload ~/Downloads/file.pdf /
```

The helper uploads with `--acl public-read`, sets `Content-Type` from the local file MIME type, and prints the public URL. Return that printed URL to the user.

When running from Codex, networked upload commands require escalation. Before upload, check the local file exists with `ls -lh <file>`.

## Direct AWS Commands

Use these if the helper is unavailable or the user asks for lower-level commands:

```bash
aws s3 cp "<local-file>" "s3://growthpanda/<prefix>/<filename>" \
  --profile do-spaces \
  --endpoint-url https://blr1.digitaloceanspaces.com \
  --acl public-read \
  --content-type "<mime-type>"
```

List:

```bash
aws s3 ls s3://growthpanda/<prefix>/ \
  --profile do-spaces \
  --endpoint-url https://blr1.digitaloceanspaces.com
```

Delete:

```bash
aws s3 rm s3://growthpanda/<key> \
  --profile do-spaces \
  --endpoint-url https://blr1.digitaloceanspaces.com
```

## Verification

For public uploads, verify with a `HEAD` request when useful:

```bash
python3 -c 'import urllib.request; url="<public-url>"; r=urllib.request.urlopen(urllib.request.Request(url, method="HEAD"), timeout=15); print(r.status, r.headers.get("Content-Type"), r.headers.get("Content-Length"))'
```

Treat `200` as reachable. After deletion, authenticated `aws s3 ls s3://growthpanda/<key>` returning no output and exit code `1` means the object is absent.

## Script

Bundled helper: `scripts/spaces-upload`

Use it directly with:

```bash
/path/to/skill/scripts/spaces-upload <local-file> <folder-or-prefix>
```
