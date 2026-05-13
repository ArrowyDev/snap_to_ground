<p align="center">
  <img src="https://github.com/ArrowyDev/snap_to_ground/blob/main/pluginicon.png" alt="Snap to Ground Icon" width="96" height="96">
</p>

<h1 align="center">Snap to Ground</h1>

<p align="center">
  A simple and fast <b>Godot editor plugin</b> that snaps selected <code>Node3D</code> objects<br>
  to the nearest valid <b>mesh surface below them</b> with a single click.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Godot-4.x-478cbf?logo=godot-engine&logoColor=white" alt="Godot 4.x">
  <img src="https://img.shields.io/badge/Type-Editor%20Plugin-7d4cff" alt="Editor Plugin">
  <img src="https://img.shields.io/badge/Language-GDScript-ffb000" alt="GDScript">
  <img src="https://img.shields.io/badge/Status-Active-32c766" alt="Status Active">
</p>

---

<h2>✨ Overview</h2>

<p>
<b>Snap to Ground</b> is a lightweight tool for <b>Godot 3D scene editing</b>.  
It helps you quickly place props, decorations, and other objects onto the surface below them without manually adjusting their position.
</p>

<p>
Select one or more <code>Node3D</code> objects, click the toolbar button, and the plugin will move them down so they rest on the highest valid mesh surface underneath.
</p>

---

<h2>🚨 Important Note</h2>

<p>
This plugin currently works by checking <b>mesh geometry</b>, not physics collisions.
</p>

<ul>
  <li>✅ Works with <code>MeshInstance3D</code> surfaces</li>
  <li>❌ Does <b>not</b> use <code>CollisionShape3D</code></li>
  <li>❌ Does <b>not</b> use physics raycasts</li>
</ul>

<p>
So if you want to describe it accurately:
</p>

<blockquote>
It snaps selected 3D objects onto the nearest mesh surface below them.
</blockquote>

---

<h2>🧩 Features</h2>

<ul>
  <li>One-click snapping from the editor toolbar</li>
  <li>Works with multiple selected objects</li>
  <li>Automatically calculates the bottom of the selected object</li>
  <li>Finds the highest valid surface directly below</li>
  <li>Moves objects only on the <b>Y axis</b></li>
  <li>Helpful for props, environment art, and level dressing</li>
</ul>

---

<h2>📦 Installation</h2>

<ol>
  <li>Copy the plugin folder into your project:</li>
</ol>

```text
res://addons/snap_to_ground/
