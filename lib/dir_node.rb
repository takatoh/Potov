#!/usr/bin/env ruby
# encoding: utf-8


require 'find'


class DirNode

  attr_reader :path

  def initialize(path, root = false, root_path = nil)
    @path = path
    @root = root
    @root_path = root_path ? root_path : path
    @children = []
  end

  def self.read(dir)
    name = dir
    root = DirNode.new(name, true)
    Find.find(dir) do |f|
      if File.directory?(f) && f != dir
        root.add(f)
      end
    end
    root
  end

  def name
    @path.split("/")[-1]
  end

  def rel_path
    @path.sub("#{@root_path}/", "")
  end

  def add(path)
    path2 = path.sub(/#{@path}\/?/, "")
    unless path2.empty?
      m = path2.split("/")
      ch = if @children.map{|c| c.name }.include?(m[0])
        @children.select{|c| c.name == m[0] }.first
      else
        c = DirNode.new(path, false, @root_path)
        @children << c
        c
      end
      ch.add(path)
    end
    self
  end

  def to_tree(ind = 0)
    result = ""
    result << " " * ind + "#{name}\n"
    result << @children.map do |ch|
      ch.to_tree(ind + 2)
    end.join("")
    result
  end

  def to_html(ind: 0, include_root: true)
    ind = ind - 4 unless include_root
    result = ""
    result << " " * ind + "<ul>\n" if @root && include_root
    result << " " * (ind + 2) + "<li class=dir data-path=#{rel_path}>#{name}" if include_root
    unless @children.empty?
      result << "\n" if include_root
      result << " " * (ind + 4) + "<ul>\n"
      @children.map do |ch|
        result << ch.to_html(ind: ind + 4)
      end.join("")
      result << " " * (ind + 4) + "</ul>\n"
      result << " " * (ind + 2) + "</li>\n" if include_root
    else
      result << "</li>\n" if include_root
    end
    result << " " * ind + "</ul>\n" if @root && include_root
    result
  end

end   # of class DirNode


if __FILE__ == $0
  dir = ARGV.shift
  root = DirNode.read(dir)
  print root.to_html
#  print root.to_html(ind: 0, include_root: false)
end
