# Question

This directory contains the views needed to build a question.

The question building experience is broken up in 3 flavors in the form of bodies

1. `Results Body` - This displays the answer choices
2. `Editing Body` - This allows you to edit the question so you can send it
3. `Playing Body` - This allows you to select answer choices to send off answers

All 3 of these views are handled within the `QuestionViewCoordinator` where the `QuestionViewState` determines which state the `Question` view is in.

### Static Header vs Dynamic Header

These should be combined into one but for the time being the static header shows strictly static data while the dynamic header will change to editing the title if appropriate.
