# This script stores the very long credits text for the end!

extends Node
class_name CreditsText
@export_multiline var credits_text = """
[font_size=86]GAME COMPLETE![/font_size]
[font_size=28]By Tyler N. (@tyleruploads) 2026[/font_size]

[font_size=20]
# Software & Asset License Agreement

This repository contains work subject to different licences depending on their type and location within the directory tree.

---

# 1. Source Code - MIT License

Unless explicitly noted, all original software, scripts, scene logic, GDScript code files located under the `/src` directory (excluding `/src/addons` and `/src/thid-party-assets`) are released under the **MIT License**.

```text
Copyright (c) 2026 Tyler N. <https://github.com/tyleruploads>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

# 2. Original Game Assets (/src/assets) - CC-BY 4.0

All creative artwork, visual assets, and media assets located inside the `/src/assets` directory (excluding third-party assets noted below) are licensed under the Creative Commons Attribution 4.0 International License (CC-BY 4.0).

You are free to share and adapt these assets for any purpose, including commericially, provided you give appropriate credit to Tyler N. (@tyleruploads) with a link to [https://github.com/tyleruploads](https://github.com/tyleruploads).

+ **Full Legal Text:** [https://creativecommons.org/licenses/by/4.0/legalcode](https://creativecommons.org/licenses/by/4.0/legalcode)

# 3. Metadata & Branding (src/meta) - CC0 1.0 (Public Domain Dedication)

All profile pictures, avatars, logos, and meta graphics located at `/src/meta` are dedicated to the public domain under the CC0 1.0 Universal (CC0 1.0) Public Domain Dedication.

No copyright or branding rights are reserved. Anyone is free to use, copy, modify, or distribute these profile pictures and meta graphics for any purpose without requiring permission or attribution.

+ **Full legal text:** [https://creativecommons.org/publicdomain/zero/1.0/](https://creativecommons.org/publicdomain/zero/1.0/)

# 4. Third-Party Assets (/src/third-party-assets) & Addons (/src/addons) - No Claim / Original Licenses

No copyright, ownership, or exclusive rights are claimed by the maintainers of this repository over any assets located in `/src/third-party-assets` or addons located in `/src/addons`.

+ All assets and plugins retain their respective original third-party licenses, public domain dedications, or open-source terms.
+ Basic geometric shapes, solid-color utility textures, and unoriginal utility graphs located in the `/src/third-party-assets` directory are uncopyrightable under public domain / CC0 standards.

# 5. Auto-Generated & Build Artifacts

This project contains automatically generated engine files, import configuration files, and build artifacts (such as .import files). These files are automatically created by engine processes and are not subject to copyright or additional licensing restrictions under this repository.
[/font_size]
"""
