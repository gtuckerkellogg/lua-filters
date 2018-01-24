
if FORMAT == "latex" then
   local function latex(str)
      return pandoc.RawInline('latex', str)
   end

   function Para (figure)
      if (#figure.content == 1) and (figure.content[1].t == 'Image')  and (figure.content[1].title == "fig:") then
         local img = figure.content[1]
         if img.caption and img.attributes['short-caption'] then
            local short_caption = pandoc.Span(pandoc.read(img.attributes['short-caption']).blocks[1].c)
            local hypertarget = "{%%\n"
            local label = "\n"
            if img.identifier ~= img.title then
               hypertarget = string.format("\\hypertarget{%s}{%%\n",img.identifier)
               label = string.format("\n\\label{%s}",img.identifier)
            end
            return pandoc.Para {
               latex(hypertarget .. "\\begin{figure}\n\\centering\n"),
               img,
               latex("\n\\caption["), short_caption, latex("]"), pandoc.Span(img.caption),
               latex(label .."\n\\end{figure}\n}\n")
            }
         end
      end
   end
end
