# thanks https://www.reddit.com/r/MacOS/comments/16lpfg5/hidden_preference_to_alter_the_menubar_spacing/


echo reset menubar
defaults -currentHost delete -globalDomain NSStatusItemSpacing
defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding

echo set menubar
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 5
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 3