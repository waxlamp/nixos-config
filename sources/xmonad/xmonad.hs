import System.IO (Handle, hPutStrLn)
import XMonad
import Data.Ratio ((%))
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutScreens
import XMonad.Layout.TwoPane
import XMonad.Util.Run (spawnPipe)
import System.Exit
import System.Posix.Unistd (nodeName, getSystemID)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal = "@alacritty@ -e tmux"
myBorderWidth = 5

myModMask = mod4Mask -- super key
altMask = mod1Mask -- left alt

myWorkspaces = map show [1..9] ++ ["0"]

myNormalBorderColor  = "#aaaadd"
myFocusedBorderColor = "#2222dd"

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch rofi
    , ((modMask,               xK_p     ), spawn "@rofi@ -show run")

    -- close focused window
    , ((modMask .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Switch to two-pane view
    , ((modMask, xK_Escape), layoutScreens 2 (TwoPane 0.5 0.5))

    -- Restore single pane view
    , ((modMask .|. shiftMask, xK_Escape), rescreen)

    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp)

    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster)

    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
      , ((modMask,               xK_l     ), sendMessage Expand)

   -- Push window back into tiling
     , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
      , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Decrement the number of windows in the master area
      , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- Connect/disconnect from the Kitware VPN
      , ((modMask              , xK_v), spawn "@nmcli@ c up kitware passwd-file /etc/nixos/vpn-secret")
      , ((modMask .|. shiftMask, xK_v), spawn "@nmcli@ c down kitware")

    -- Toggle elgato light
      , ((modMask              , xK_e), spawn "@elgato@ toggle")

    -- Brightness control
      , ((modMask              , xK_equal), spawn "@xbacklight@ -inc 10")
      , ((modMask              , xK_minus), spawn "@xbacklight@ -dec 10")
      , ((modMask .|. shiftMask, xK_equal), spawn "@xbacklight@ -set 100")
      , ((modMask .|. shiftMask, xK_minus), spawn "@xbacklight@ -set 30")

    -- toggle the status bar gap
      , ((modMask              , xK_b), sendMessage ToggleStruts)

    -- Focus the most recently urgent window.
      , ((modMask              , xK_u), focusUrgent)

    -- Clear all urgency hints.
      , ((modMask .|. shiftMask, xK_u), clearUrgents)

    -- Lock screen.
      , ((modMask              , xK_x), spawn "@xlock@ -mode blank")

    -- Refresh autorandr setup.
      , ((modMask              , xK_d), spawn "@xrandr@ --auto")

    -- Quit xmonad
      , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
      , ((modMask              , xK_q     ), spawn "@xmonad@ --recompile && @xmonad@ --restart")
    ] ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) $ [xK_1 .. xK_9] ++ [xK_0]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]] ++

    -- mod-{[,]}, Switch to physical/Xinerama screens 1 or 2
    -- mod-shift-{[,]}, Move client to screen 1 or 2
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_bracketleft, xK_bracketright] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
      , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
      , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    ]

myLayout = avoidStruts $ (tiled ||| noBorders Full)
    where
        -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Proportion of screen to increment by when resizing panes
     delta   = 3 / 100

     -- Default proportion of screen occupied by master pane
     ratio   = 1 / 2

-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Gimp"           --> doFloat
      , className =? "feh"            --> doFloat
      , resource  =? "desktop_window" --> doIgnore
      , resource  =? "kdesktop"       --> doIgnore
    ]

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Status bars and logging
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ def { ppCurrent = xmobarColor "#33cc44" "" . wrap "<" ">"
  , ppTitle = shorten 120
  , ppSep =  "<fc=#afaf87> | </fc>"
  , ppHiddenNoWindows = xmobarColor "#afaf87" ""
  , ppUrgent = xmobarColor "#ff0000" ""
  , ppOutput = hPutStrLn h }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
defaults = def {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = myLayout,
    manageHook         = manageDocks <+> myManageHook
               }

main = do h <- spawnPipe $ "@xmobar@ ~/.xmonad/xmobarrc"
          xmonad $ docks $ defaults { logHook = myLogHook h }

