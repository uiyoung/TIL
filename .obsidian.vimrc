imap jk <Esc>
unmap <Space>

" yank to system clipboard
set clipboard=unnamed

" window controls
exmap wq obcommand workspace:close
exmap q obcommand workspace:close
nmap <Space>q :wq

" Splits
exmap splitVertical obcommand workspace:split-vertical
exmap splitHorizontal obcommand workspace:split-horizontal
nmap <Space>v :splitVertical
nmap <Space>s :splitHorizontal

" Focus
exmap focusRight obcommand editor:focus-right
exmap focusLeft obcommand editor:focus-left
exmap focusTop obcommand editor:focus-top
exmap focusBottom obcommand editor:focus-bottom
nmap <Space>l :focusRight
nmap <Space>h :focusLeft
nmap <Space>k :focusTop
nmap <Space>j :focusBottom

