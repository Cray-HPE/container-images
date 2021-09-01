# Build Sign Scan Composite Action

All the workflows we have right now are pretty much copy and paste.

Using a composite action in github wofklows will keep things more DRY

But right now it appears only `shell` steps are supported in actions and there is no ability to have a composite action call another action.

See
https://github.com/actions/runner/issues/646
https://github.com/actions/runner/issues/438
https://github.com/actions/runner/pull/612

Once that is ready we should be able to create simpler workflows that look more like the example.yaml
