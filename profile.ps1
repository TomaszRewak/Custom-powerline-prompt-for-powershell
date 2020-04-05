function prompt {
    class Color {
        [int] $R
        [int] $G
        [int] $B

        static [Color] $Default = $null

        Color([int] $r, [int] $g, [int] $b) {
            $this.R = $r
            $this.G = $g
            $this.B = $b
        }

        static [string] Foreground([Color] $color) {
            if ($color) {
                return "$([char]0x1B)[38;2;$($color.R);$($color.G);$($color.B)m"
            }
            else {
                return "$([char]0x1B)[39m"
            }
        }

        static [string] Background([Color] $color) {
            if ($color) {
                return "$([char]0x1B)[48;2;$($color.R);$($color.G);$($color.B)m"
            }
            else {
                return "$([char]0x1B)[49m"
            }
        }
    }

    class PromptBuilder {
        hidden [string] $Text
        hidden [Color] $Foreground
        hidden [Color] $Background
        hidden [string] $Separator
        hidden [string] $ReversedSeparator

        PromptBuilder() {
            $this.Text = ""
            $this.Foreground = $null
            $this.Background = $null
            $this.Separator = $null
            $this.ReversedSeparator = $null
        }

        hidden PromptBuilder(
            [string] $text,
            [Color] $foreground,
            [Color] $background,
            [string] $separator,
            [string] $reversedSeparator
        ) {
            $this.Text = $text
            $this.Foreground = $foreground
            $this.Background = $background
            $this.Separator = $separator
            $this.ReversedSeparator = $reversedSeparator
        }

        [PromptBuilder] WithForeground([Color] $color) {
            return [PromptBuilder]::new(
                $this.Text,
                $color,
                $this.Background,
                $this.Separator,
                $this.ReversedSeparator
            )
        }

        [PromptBuilder] WithText([string] $text) {
            return $this.WithText($text, $this.Background)
        }

        [PromptBuilder] WithText([string] $text, [Color] $background) {
            return [PromptBuilder]::new(
                "$($this.Text)$([Color]::Foreground($background))$([Color]::Background($this.Background))$($this.ReversedSeparator)$([Color]::Foreground($this.Background))$([Color]::Background($background))$($this.Separator)$([Color]::Foreground($this.Foreground))$text",
                $this.Foreground,
                $background,
                $null,
                $null
            )
        }

        [PromptBuilder] WithSeparator([char] $separator) {
            return [PromptBuilder]::new(
                $this.Text,
                $this.Foreground,
                $this.Background,
                "$separator",
                $null
            )
        }

        [PromptBuilder] WithoutSeparator() {
            return [PromptBuilder]::new(
                $this.Text,
                $this.Foreground,
                $this.Background,
                $null,
                $null
            )
        }

        [PromptBuilder] WithReversedSeparator([char] $separator) {
            return [PromptBuilder]::new(
                $this.Text,
                $this.Foreground,
                $this.Background,
                $null,
                "$separator"
            )
        }

        [string] ToString() {
            $final = $this.WithForeground([Color]::Default).WithText("", [Color]::Default)
            return $final.Text
        }
    }

    $path = $(Get-Location).Path
    $sections = $path.Split([char]'\')
    $level = 0

    $git_root = -1
    if ($(git rev-parse --is-inside-work-tree) -eq "true")
    {
        $git_root = $(git rev-parse --show-toplevel).Split([char]'/').Length - 1
        $git_branch = $(git rev-parse --abbrev-ref HEAD)
    }
    
    $builder = [PromptBuilder]::new()
    $builder = $builder.WithReversedSeparator(0xE0CA)

    if ($sections[0].EndsWith(":"))
    {
        $builder = $builder.WithText(" $($sections[0].TrimEnd([char]':'))", [Color]::new(227, 146, 52))
        $builder = $builder.WithSeparator(0xE0B4)

        $level += 1
    }

    if ($path.StartsWith("C:\Users\tomas"))
    {
        $builder = $builder.WithText(" Tomasz ", [Color]::new(52, 128, 235))
        $builder = $builder.WithSeparator(0xE0B8)

        $level += 2
    }

    if ($path.StartsWith("C:\Users\tomas\Programy"))
    {
        $builder = $builder.WithText(" 💻 ", [Color]::new(54, 109, 186))
        $builder = $builder.WithSeparator(0xE0B8)

        $level += 1
    }
    
    for(; $level -lt $sections.Length; $level++)
    {
        if ($level -eq $git_root) {
            $builder = $builder.WithText(" $($sections[$level]) ", [Color]::new(70, 138, 74))
            $builder = $builder.WithSeparator(0xE0A0)
            $builder = $builder.WithText(" $git_branch ", [Color]::new(72, 163, 77))
        }
        elseif ($sections[$level] -eq "Debug" -or $sections[$level] -eq "Release")
        {
            $builder = $builder.WithReversedSeparator(0xE0C2)
            $builder = $builder.WithText(" $($sections[$level]) ", [Color]::new(186, 54, 54))
        }
        elseif ($level % 2 -eq 0) {
            $builder = $builder.WithText(" $($sections[$level]) ", [Color]::new(99, 99, 99))
        }
        else {
            $builder = $builder.WithText(" $($sections[$level]) ", [Color]::new(80, 80, 80))
        }

        $builder = $builder.WithSeparator(0xE0B8)
    }

    $builder = $builder.WithoutSeparator()
    $builder = $builder.WithSeparator(0xE0B0)
    $builder = $builder.WithText(" ", [Color]::Default)

    return $builder.ToString()
}