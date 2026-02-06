---
name: zendesk-markdown
description: Convert Markdown text to Zendesk-compatible HTML. Use when user needs to format content for Zendesk tickets, macros, triggers, or automations.
---

# Zendesk Markdown to HTML Converter

Convert Markdown-formatted text into HTML that works correctly in Zendesk Support (triggers, automations, dynamic content, email templates, macros).

## Usage

User provides Markdown text, and you convert it to clean, minified HTML.

## Conversion Rules

### Text Formatting

| Markdown | HTML |
|----------|------|
| `**bold**` | `<strong>bold</strong>` |
| `*italic*` | `<em>italic</em>` |
| `` `code` `` | `<code>code</code>` |

### Headings

| Markdown | HTML |
|----------|------|
| `# Heading 1` | `<h1>Heading 1</h1>` |
| `## Heading 2` | `<h2>Heading 2</h2>` |
| `### Heading 3` | `<h3>Heading 3</h3>` |
| `#### Heading 4` | `<h4>Heading 4</h4>` |

### Lists

**Bulleted list:**
```markdown
* Item one
* Item two
```
→
```html
<ul><li>Item one</li><li>Item two</li></ul>
```

**Numbered list:**
```markdown
1. Step one
2. Step two
```
→
```html
<ol><li>Step one</li><li>Step two</li></ol>
```

**Nested lists:** Use nested `<ul>` or `<ol>` inside `<li>` elements.

### Links and Images

| Markdown | HTML |
|----------|------|
| `[Link text](https://example.com)` | `<a href="https://example.com">Link text</a>` |
| `![Alt text](https://example.com/image.png)` | `<img src="https://example.com/image.png" alt="Alt text">` |

### Block Elements

**Code block:**
````markdown
```
code here
```
````
→
```html
<pre><code>code here</code></pre>
```

**Blockquote:**
```markdown
> Quoted text
```
→
```html
<blockquote>Quoted text</blockquote>
```

**Horizontal rule:**
```markdown
---
```
→
```html
<hr>
```

### Paragraphs

Separate paragraphs with blank lines → wrap each in `<p>` tags.

```markdown
First paragraph.

Second paragraph.
```
→
```html
<p>First paragraph.</p><p>Second paragraph.</p>
```

## Output Requirements

1. **Minify the HTML**: Write on a single line with no unnecessary whitespace. Zendesk renders extra gaps/spaces in emails if HTML isn't minified.

2. **Valid HTML only**: Don't include markdown artifacts or partial conversions.

3. **Escape special characters**: Convert `<` to `&lt;`, `>` to `&gt;`, `&` to `&amp;` in text content (not in HTML tags).

4. **No outer wrapper**: Don't wrap entire output in `<div>` or `<body>` unless specifically requested.

## Example Conversion

**Input:**
```markdown
# Welcome

Thank you for contacting us!

We'll help you with:
* Account issues
* Billing questions
* Technical support

Please **reply** to this email or visit [our help center](https://help.example.com).
```

**Output:**
```html
<h1>Welcome</h1><p>Thank you for contacting us!</p><p>We'll help you with:</p><ul><li>Account issues</li><li>Billing questions</li><li>Technical support</li></ul><p>Please <strong>reply</strong> to this email or visit <a href="https://help.example.com">our help center</a>.</p>
```

## Zendesk Context Notes

- HTML works in: triggers, automations, dynamic content, email templates, CC emails, welcome emails, verification emails
- Markdown works in: agent signatures, macros (with rich content disabled), comment sections
- Dynamic content in triggers/automations may have inconsistent HTML rendering - keep it simple
- Always minify to avoid spacing issues in delivered emails

## Workflow

1. Parse the user's Markdown input
2. Convert each element to its HTML equivalent using the rules above
3. Minify the output (single line, no extra whitespace)
4. Present the HTML in a code block for easy copying
5. Optionally offer a "pretty-printed" version if the user needs to edit it
