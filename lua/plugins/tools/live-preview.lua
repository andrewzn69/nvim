return {
  'brianhuster/live-preview.nvim',
  desc = 'live browser preview of Markdown, HTML, AsciiDoc and SVG',
  event = 'VeryLazy',
  config = function()
    require('livepreview.config').set({
      port = 6767,
      browser = 'firefox',
    })
  end,
}
