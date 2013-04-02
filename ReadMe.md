Sample RSS reader app. Simple RSS/XML parsing, UI customization, native CSS styling, etc.

Known issues:
- RSS loading & parsing process unsafe. If you hit "Refresh" button many times in short time, application may crash. To fix this issue, it is important to manage queues & cancel current (active) one before starting another one.
